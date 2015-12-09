Lists resources across all regions. Useful to find "forgotten" resources that might be incurring costs, or when responding to a compromise event.

- list_all.sh: Lists EC2 resources that incur costs, this is an 'omnibus' script that invokes others that list resources such as EC2 instances, EBS volumes, etc.
- list_spot_instance_requests.sh: Lists all spot instance requests across all regions
- list_ebs_volumes.sh: Lists all EBS volumes across all regions
- list_snapshots.sh: Lists all EBS volume snapshots
