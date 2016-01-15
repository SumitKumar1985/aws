Available:
====

- create_asg_from_blueprint_instance.sh: Create an Auto Scaling Group using an existing instance as the 'blueprint' for the initial launch configuration

TODO:
====

- Create an AutoScaling Group
- Use cloud-init to configure a web server
- Register new instances with an ELB as they join the group
- Create multiple launch configurations and demonstrate when each is chosen by AutoScaling to start new instances (or terminate existing ones)
