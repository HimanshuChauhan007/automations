from email.headerregistry import Group
from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.storage import S3
from diagrams.aws.network import NLB
from diagrams.aws.network import CF
from diagrams.onprem.network import Nginx
from diagrams.aws.network import ALB
from diagrams.aws.storage import EFS
from diagrams.aws.storage import Storage


with Diagram(""):

    CDN = CF("Name")
    NLB = NLB("Name")
    
    with Cluster("Type Cluster Name"):
        Web = [EC2(""),
                EC2("")]
    ALB = ALB("Name")
    
    with Cluster("Type Cluster Name"):
        Web2 = [EC2(""),
                EC2("")]
    
    EFS = EFS("Name")
    DB = Storage("Name")
    S3 = S3("Name")

    CDN >> NLB >> Web >> ALB >> Web2
    Web2 >> Edge (label="") << EFS 
    EFS - Edge(color="brown", style="dashed") - DB - Edge(color="brown", style="dashed") - S3