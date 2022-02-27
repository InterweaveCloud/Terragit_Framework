# Terragit_Framework

## Bacground

Terraform is a very popular tool for Infrastructure as Code, however while the software itself is now mature with several large stable providers, few frameworks and complete guides exist for utilising terraform within the real world. One of the most complete guides is contained within the Terraform Up and Running book however, despite many good practices, the framework defined for collaborating on and automating terraform is believed to be fundamentally flaws.

The Terragit framework will attempt to provide an alternative framework for automating terraform, with a focus on the following:

- DRY - Don't Repeat Yourself
- Scaleable - The framework can can support very large infrastructure as well as small
- Reusable - The framework can support various implementations e.g different backends
- Progressive Complexity - The framework provides a low requirement of overhead work to get started initially and then progressively adds more functionality as the project grows
- Git - Leverage the full git capabilities to implement traditional, battle tested git workflows

## Overview

This repository presents a framework for terraform based CI/CD pipelines. Several exercises are provided to demonstrate the decisions made when designing the framework.

### Stage 1 - Overview

Stage 1 explores the core decision of how to handle environments and branching within the framework.

The following exercises are provided:

1. Exercise 1 - demonstrates how utilising traditional feature branches with terraform is not possible without a CICD pipeline.
2. Exercise 2 - demonstrates how feature branches can still be with terraform once utilising a CICD pipeline.
3. Exercise 3 - demonstrates a new paradigm of feature environments for terraform based CI/CD.

### Stage 1 - Review

From exercise 1 it is clear that a centralised runner for terraform is required and that traditional feature branching is not a viable solution for Terraform.

Exercise 2 explores the workflow which is demonstrated in most tutorials, using a trunk environment with a feature branch which executes a terraform plan on a pull request. This approach is marginally better than just working directly of the trunk branch. Terraform plans can frequently be incorrect. There is also a large amount of overhead work required for testing each small interation of code added. Additionally, there will be frequent noise from developers stepping on eachothers toes.

Exercise 3 explores how a branch environment variable can be detected to create a new environment per branch. This is a much more robust approach to feature branching. and the automation involved in picking up this variable ensured no errors occur due to manual errors.

However exercise 3 leaves several issues to be resolved:

- Whether to use terraform workspaces or completely different backends to divide state
- How to dynamically manage variables to achieve variable environment configuration
- How to break up large monolithic terraform configurations
- How to interact with terraform modules

These will be explored in stage 2 where these will be explored.
