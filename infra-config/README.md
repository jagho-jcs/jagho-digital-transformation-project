# What is Infrastructure as Code?

**Cloud** computing provides on-demand computing resources, which are decoupled from physical hardware and necessary underlying configuration.

Autonomous software systems provision these computing resources in the `cloud` to achieve the automation that the `cloud` computing offers.  Because of such automation, it's possible to control and manipulate the available resources pro-grammatically by interfacing with the `cloud` providers.  

This way, infrastructure changes (such as resource scaling) can be implemented more quickly and reliably and operated mostly without manual interaction, but still with the ability to oversee the whole process and revert changes if something does not go according to plan.

_**Infrastructure as Code (IaC)**_ is the approach of automating infrastructure deployment and changes by defining the desired resource states and their manual relationships in code.  The code is written in specialized, human-readable languages of IaC tools.  The actual resources in the `cloud` are created (or modified) when you execute the code.  This then prompts the tool to interface with the `cloud` provider or deployment system on your behalf to apply the necessary changes, without using a `cloud` provider's web interface.

The code can be modified whenever needed-upon code execution the `IaC` tool will take care of finding the differences between the desired infrastructure in code and the actual infrastructure in the `cloud` taking steps to make the actual state equal to the desired one.

For `IaC` to work in practice, created resources must not be manually modified afterwards **(an immutable infrastructure),** as this creates discord between the expected infrastructure in code and the actual state in the `cloud`.  In addition, the manually modified resources could get recreated or deleted during future code executions, and all such customization would be lost.  The solution to this is to incorporate the modifications into the infrastructure code.

The purpose of _**infrastructure as code**_ is to enable developers or operations teams to automatically manage, monitor and provision resources, rather than manually configure discrete hardware devices and operating systems. Infrastructure as code is sometimes referred to as programmable or software-defined infrastructure.