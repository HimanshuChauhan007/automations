#This script deregister the AMI and deletes the associated snapshots for the AMI date of "DeleteOnCopy" expired.

import boto3
import collections
import datetime
import time
import sys

#specify the destination region to AMI's copied to cleanup. Ex: Ohio region (us-east-2)
ec = boto3.client('ec2', 'us-east-2')
ec2 = boto3.resource('ec2', 'us-east-2')
images = ec2.images.filter(Owners=["609414041596"]) # Specify your AWS account owner id in place of "XXXXX" at all the places in this script

def lambda_handler(event, context):

    to_tag = collections.defaultdict(list)

    date = datetime.datetime.now()
    date_fmt = date.strftime('%d-%m-%Y')
    print ("Today's date and time:" + date.strftime('%d-%m-%Y:%H.%m.%s'))
    
    imagesList = []
    # Loop through each image of our current instance
    for image in images:
        try:
            if image.tags is not None:
                deletion_date = [
                    t.get('Value') for t in image.tags
                    if t['Key'] == 'DeleteOnCopy'][0]
                
                delete_date = time.strptime(deletion_date, "%d-%m-%Y")
                #print ("deletion_date %s" %delete_date)
                
                #today = datetime.datetime.now()
                #today_date = today.strftime('%d-%m-%Y')
                today_time = datetime.datetime.now().strftime('%d-%m-%Y')
                today_date = time.strptime(today_time, '%d-%m-%Y')
                # print ("today_date %s" %today_date)
                
                # If image's DeleteOn date is less than or equal to today,
                # add this image to our list of images to process later
                if delete_date < today_date:
                    imagesList.append(image.id)
  
        except IndexError:
             deletion_date = False
             delete_date = False
        
        
    print ("=============")

    print ("About to process the following AMIs:")
    print (imagesList)

    snapshotList = []
    # Loop through each image of our current instance
    for image in imagesList:
        #print image
        desc_image_snapshots = ec.describe_images(ImageIds=[image],Owners=['609414041596',])['Images'][0]['BlockDeviceMappings']
       # print (desc_image_snapshots)
        try:
            for desc_image_snapshot in desc_image_snapshots:
                snapshot = ec.describe_snapshots(SnapshotIds=[desc_image_snapshot['Ebs']['SnapshotId'],], OwnerIds=['609414041596'])['Snapshots'][0]
                #if snapshot['Description'].find(image) > 0:
                snapshotList.append(snapshot['SnapshotId'])
                #else:
                #continue
                #print "Snapshot is not associated with an AMI"
                
        except Exception as e:
            print ("Ignore Index Error:%s" % e.message)
            
        print ("Deregistering image %s" % image)
        try:
            amiResponse = ec.deregister_image(
                    DryRun=False,
                ImageId=image,
            )
            #print "For testing, commented ami de-register"
        except Exception as e:
            print ("%s" % e.message)


    print ("=============")
        
    print ("About to process the following Snapshots associated with above Images:")
    print (snapshotList)
        
    print ("The timer is started for 5 seconds to wait for images to deregister before deleting the snapshots associated to it")    
    time.sleep(5)# This should be set to higher value if the image in the imagesList takes more time to deregister
        
    for snapshot in snapshotList:
        try:
            snap = ec.delete_snapshot(SnapshotId=snapshot)
            print ("Deleted snapshot " + snapshot)
            
        except Exception as e:
            print ("%s" % e.message)
    print ("-------------")