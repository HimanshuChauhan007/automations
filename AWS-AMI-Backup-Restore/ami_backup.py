#This script copies the AMI to other region and tag copied AMI 'DeleteOnCopy' with retention  days specified.
import boto3
import json
from dateutil import parser
import dateutil
import datetime
import collections

#Specify the source region of AMI's created and the destination region to which AMI's to be copied
source_region = 'us-east-1'
source_image_resource = boto3.resource('ec2',source_region)
dest_image_client = boto3.client('ec2','us-east-2')
dest_image_resource  = boto3.resource('ec2','us-east-2')

#Mention AMI to be retained for the number of days in the destination region.
ami_retention = 1

def copy_latest_image():
    images = source_image_resource.images.filter(Owners=["609414041596"]) # Specify your AWS account owner id in place of "XXXXX" at all the places in this script
    
    #Retention days in DR region, its for 15 days.
    retention_days = int(ami_retention)
	
    to_tag = collections.defaultdict(list)
    
    for image in images:
        image_date = parser.parse(image.creation_date)
        
        #Copy todays images
        if image_date.date() == (datetime.datetime.today()).date(): 
        
	    #To Copy previous day images
        #if image_date.date() == (datetime.datetime.today()-datetime.timedelta(1)).date(): 
		            
            if not dest_image_client.describe_images(Owners=['609414041596',],Filters=[{'Name':'name','Values':[image.name]}])['Images']:
            #if not dest_image_client.describe_images(Owners=['XXXXX',])['Images']:
            
                print ("Copying Image {name} - {id} to Ohio".format(name=image.name,id=image.id))
                new_ami = dest_image_client.copy_image(
                    DryRun=False,
                    SourceRegion=source_region,
                    SourceImageId=image.id,
                    Name=image.name,
                    Description=image.description
                )
                
                to_tag[retention_days].append(new_ami['ImageId'])
                
                print ("New Image Id {new_id} for Virginia Image {name} - {id}".format(new_id=new_ami,name=image.name,id=image.id))
                
                
                print ("Retaining AMI %s for %d days" % (
                        new_ami['ImageId'],
                        retention_days,
                    ))
                    
                for ami_retention_days in to_tag.keys():
                    delete_date = datetime.date.today() + datetime.timedelta(days=retention_days)
                    delete_fmt = delete_date.strftime('%d-%m-%Y')
                    print ("Will delete %d AMIs on %s" % (len(to_tag[retention_days]), delete_fmt))
                    
                    #To create a tag to an AMI when it can be deleted after retention period expires
                    dest_image_client.create_tags(
                        Resources=to_tag[retention_days],
                        Tags=[
                            {'Key': 'DeleteOnCopy', 'Value': delete_fmt},
                            ]
                        )
            else:
                print ("Image {name} - {id} already present in Ohio Region".format(name=image.name,id=image.id))

def lambda_handler(event, context):
    copy_latest_image()


if __name__ == '__main__':
    lambda_handler(None, None)
