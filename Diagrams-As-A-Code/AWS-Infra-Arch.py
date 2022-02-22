from errno import ENOTCONN
from linecache import lazycache
from locale import RADIXCHAR
from operator import truediv
from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.compute import Lambda
from diagrams.aws.storage import S3
from diagrams.azure.security import Sentinel
from diagrams.aws.integration import SNS
from diagrams.aws.integration import MQ
from diagrams.aws.database import DocumentDB 
from diagrams.aws.integration import SimpleQueueServiceSqsQueue
from diagrams.aws.enablement import ManagedServices
from diagrams.generic.compute import Rack
from diagrams.aws.network import RouteTable
from diagrams.elastic.elasticsearch import Elasticsearch
from diagrams.elastic.elasticsearch import Monitoring
from diagrams.generic.device import Tablet

with Diagram(""):
    with Cluster(""):
            Tab = Tablet("Name")
            IIS = RouteTable("Name") 
            IIS >> Edge(label="Whatever you want to right") << ManagedServices("Name")
            Tab >> Edge(label="Whatever you want to right") >> IIS

            with Cluster(""):
                S1 = S3("Name")
                Lam = Lambda("Name")
                EC = EC2("Name")
                Tab >> Edge(label="Whatever you want to right") >> S1
                Lam - Edge(label="Whatever you want to right") - S1
                EC >> Edge(label="Whatever you want to right") << Lam
                Lam >> Edge(label="Whatever you want to right") >> S1
            
        
                Lam2 = Lambda("Name")
                Que1 = SimpleQueueServiceSqsQueue("Name")
                Que2 = SimpleQueueServiceSqsQueue("Name")
                S1 >> Edge(label="Whatever you want to right") >> Lam2
                Lam2 - Edge(label="Whatever you want to right") - Lam2
                Lam2 >> Edge(label="Whatever you want to right") >> Que1
                Lam2 >> Edge(label="Whatever you want to right") >> Que2

                with Cluster(""):
                    Manage1 = ManagedServices("Name")
                    MQ1 = MQ("Name")
                    Que3 = SimpleQueueServiceSqsQueue("Name")
                    Manage1 >> Edge(label="Whatever you want to right") >> Que2
                    Manage1 >> Edge(label="Whatever you want to right") >> Que3 
                    Que1 >> Edge(label="Whatever you want to right") >> MQ1

                    Manage2 = ManagedServices("Name")
                    Rack1 = ManagedServices("Name")
                    Rack2 = ManagedServices("Name")
                    Que4 = SimpleQueueServiceSqsQueue("Name")
                    MQ1 >> Que3
                    MQ1 >> Manage2
                    MQ1 >> Edge(label="Whatever you want to right") >> Rack1
                    MQ1 >> Edge(label="Whatever you want to right") >> Rack2
                    MQ1 >> Edge(label="Whatever you want to right") >> Que4


    with Cluster(""): 
        MQ2 = MQ("Name")
        Que5 = SimpleQueueServiceSqsQueue("Name")
        Etl = Monitoring("Name")
        S2 = S3("Name")
        Rack3 = Rack("Name")
        Rack4 = Rack ("Name")
        MQ2 >> Que5
        MQ2 >> Que4
        Etl >> Edge(label="Whatever you want to right") << Que5
        Etl >> S2
        Etl >> Rack3
        Etl >> Edge(label="Whatever you want to right") >> Rack4
        Rack4 - Edge(label="Whatever you want to right") - Rack4

        with Cluster(""):
                MQ3 = MQ("Name")
                SNS = SNS("Name")
                with Cluster(""):
                    Que6 = [SimpleQueueServiceSqsQueue("Name"),
                                SimpleQueueServiceSqsQueue("Name"),
                                SimpleQueueServiceSqsQueue("Name"),
                                SimpleQueueServiceSqsQueue("Name")]
        Que7 = SimpleQueueServiceSqsQueue("Name")
        MQ4 = MQ("Name")
        MQ5 = MQ("Name")
        Rack5 = ManagedServices("Name")
        Db1 = DocumentDB("Name")
        Db2 = DocumentDB("Name")
        Db3 = DocumentDB("Name")
        Manage3 = ManagedServices("Name")
        Elastic = Elasticsearch("Name")
        Que5 >> MQ3
        MQ3 >> SNS
        MQ3 >> Db1
        Db1 >> Edge(label="Whatever you want to right") >> Db2
        Db1 >> Edge(label="Whatever you want to right") >> Db3
        Db3 >> Manage3
        SNS >> Que6
        SNS >> Que7
        Que6 >> MQ4
        Rack5 >> Edge(label="Whatever you want to right") << MQ4
        MQ4 >> Que7
        MQ4 >> Manage3
        Que7 >> MQ5
        MQ5 >> Edge(label="Whatever you want to right") >> Elastic