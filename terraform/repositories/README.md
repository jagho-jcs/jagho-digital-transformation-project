# GitOps: The Future of Infrastructure Automation

With the demands made on today's infrastructure, it's crucial for organizations to implement infrastructure automation that is repeatable, traceable, and less prone to human error. GitOps takes DevOps best practices used for application development, such as version control, collaboration, compliance, and CI/CD, and applies them to modern infrastructure automation.

## Why you should care about GitOps?

GitOps is a paradigm or a set of practices that empowers developers to perform tasks which typically fall under the purview of IT operations. GitOps requires us to describe and observe systems with declarative specifications that eventually form the basis of continuous everything. (As a refresher, continuous everything includes but is not limited to continuous integration (CI), testing, delivery, deployment, analytics, governance with many more to come).

## What is GitOps?

GitOps upholds the principle that `GIT` is the one and only source of truth. GitOps requires the desired state of the system to be stored in a `version control` system such that anyone can view the entire audit trail of changes. All changes to the desired state are fully traceable commits associated with committer information, commit IDs and time stamps. This means that both the application and the infrastructure are now versioned artifacts and can be audited using the gold standards of software development and delivery.

**Declarative specification for each environment**

GitOps requires us to describe the desired state of the whole system using a declarative specification for each environment. This becomes the system of record. You can describe your environments such as test, staging and production in a code repo, along with the application version that resides in that environment.

## What is a Repository?

In software development, a `repository` is a central file storage location. It is used by version control systems to store multiple versions of files. ... This may include multiple source code files, as well as other resources used by the program. Branches are used to store new versions of the program.

### What is a Code Repository used for?

What is `Code Repository` Software? A source `code repository`, or simply `code repository`, is essentially a file archive and web hosting facility where programmers, software developers, and designers store large amounts of source `code` for the software and/or web pages for safekeeping.