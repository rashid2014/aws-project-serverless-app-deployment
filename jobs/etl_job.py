import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions

# Get Job Arguments
args = getResolvedOptions(sys.argv, ['JOB_NAME', 's3_input_path', 's3_output_path'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Load data from S3 (automatically detects file type)
df = spark.read.format("json").load(args['s3_input_path'])
# For CSV use:
# df = spark.read.option("header", "true").csv(args['s3_input_path'])

# Transform — example: filter, clean, derive fields
df_clean = (
    df.filter("age >= 30")
      .withColumnRenamed("name", "full_name")
      .withColumn("age_category",
                  (df.age >= 30).cast("int"))
)

# Write Output to S3 as Parquet
df_clean.write.mode("overwrite").parquet(args['s3_output_path'])

job.commit()
