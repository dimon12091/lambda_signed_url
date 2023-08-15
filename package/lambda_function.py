import os
import boto3
from botocore.signers import CloudFrontSigner
from datetime import datetime, timedelta, timezone
import rsa

# Secrets to fetch from AWS Security Manager
KEY_KEY_ID=os.environ['KEY_KEY_ID']
KEY_PRIVATE_KEY=os.environ['KEY_PRIVATE_KEY']

def get_secret(parameter_name):
    # Create an SSM client using the session
    ssm_client = boto3.client('ssm')

    # Retrieve the parameter value
    response = ssm_client.get_parameter(
        Name=parameter_name,
        WithDecryption=True  # Set to False if the parameter value is not encrypted
    )

    # Extract the parameter value from the response
    parameter_value = response['Parameter']['Value']

    return parameter_value
def rsa_signer(message):
   private_key = get_secret(KEY_PRIVATE_KEY)
   return rsa.sign(
       message,
       rsa.PrivateKey.load_pkcs1(private_key.encode('utf8')),
       'SHA-1')  # CloudFront requires SHA-1 hash


def sign_url(url_to_sign, days_valid=0, hours=0, minutes=0):
    key_id = get_secret(KEY_KEY_ID)
    cf_signer = CloudFrontSigner(key_id, rsa_signer)
    expiration_time = datetime.now(timezone.utc) + timedelta(days=days_valid, hours=hours, minutes=minutes)
    signed_url = cf_signer.generate_presigned_url(url=url_to_sign, date_less_than=expiration_time)
    return signed_url

def lambda_handler(event, context):

    domain = "https://static.ed3p.net/"
    full_path = domain + event['path']

    signed_url = sign_url(full_path, days_valid=0, hours=0, minutes=1)
    print(signed_url)
