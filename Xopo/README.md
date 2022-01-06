# 1 Dockerfile
# 2 ecs.tf
# 3 Jenkinsfile.btc

# 4.

Currently, Amazon VPC supports five (5) IP address ranges, one (1) primary and four (4) secondary for IPv4. Each of these ranges can be between /28 (in CIDR notation) and /16 in size i.e The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses). After you've created your VPC, you can associate secondary CIDR blocks with the VPC. For more information. The IP address ranges of your VPC should not overlap with the IP address ranges of your existing network.

Though , Amazon VPC supports IPv4 and IPv6 addressing, and has different CIDR block size quotas for each. By default, all VPCs and subnets must have IPv4 CIDR blocks—you can't change this behavior. You can optionally associate an IPv6 CIDR block with your VPC.

Thus this would not satisfy the five pillars of AWS Well-Architected Framework.

*Note - 
The pillars of the AWS Well-Architected Framework


# 5.  
Open main.tf

# 6.
 How would you provision runtime parameters such as database connection strings, credentials into Docker containers so they can be used in different environments (development, staging, production)? Please take into account that parameters might change often as the development team adds new options or changes existing ones.

Usual method,
 For passing parameters into Docker containers would be adding them in the Dockerfile but not in this case , also for sensitive information it doesn’t makes sense to pass them as environment var, 

In this case,
 Because it might change more frequency it would be easier to define them as build arg then call them during docker build itself without storing anywhere ! ie. docker build --build-arg Database_CS=“connection_string” ( you can use multiple build args ) 

However , 
 If it need not be changed frequently then secret store or vault would come into picture. ( or read only volume , docker swarm / k8s secrets ,** using DOCKER_BUILDKIT & for aws creds
 aws-sdk-secretsmanager or directly assume role with time limits ) 

# 7. 
Imagine you have an EC2 instance running in production and for some reason you and your team don't have access to the PEM key configured on it. What other options do you have to connect to that EC2 instance over SSH?

Easiest ( non recommended )  create new user in EC2 machine and edit inside “sudo vi /etc/ssh/sshd_config “ , Change PasswordAuthentication "yes" to "no" Or login using password of newly created user instead of pem. ( little more secure )

Suggest Approach - 
Enable to handle authentication to Ec2 , with AWS SSO.
This setup requires a ssh script to pass ssh connections through AWS SSM. Thus it’s actually AWS SSM that authenticates / identifies you removing the need to validating or even carry/share .pem files which could case security concern if leaked.
Prerequisites include - aws-cli, AWS-SSM plugin, ProxyCommand & will have to forward your sim agent so that your ssh authentication can be passed through.
