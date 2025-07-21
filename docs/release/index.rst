..
  This work is licensed under a Creative Commons Attribution 4.0
  International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

'Paris' Release Notes
=====================

This page provides the release notes for the latest ONAP release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

'Oslo' Major Release 15.0.0
---------------------------

+-----------------------------------+-----------------------------------------+
| **Project**                       | ONAP                                    |
+-----------------------------------+-----------------------------------------+
| **Release name**                  | Paris                                   |
+-----------------------------------+-----------------------------------------+
| **Release version**               | 16.0.0                                  |
+-----------------------------------+-----------------------------------------+
| **Release date**                  | 2025, July 10th                         |
+-----------------------------------+-----------------------------------------+

ONAP is a comprehensive collection of Network Automation functions, including
orchestration, management, and automation of network and edge computing
services for network operators, cloud providers, and enterprises.

The ONAP Paris release continues the ONAP Streamlining evolution, advancing
individual ONAP components and clusters, enhancing security, modernizing
environments, and supporting intent-based declarative solutions and GenAI
capabilities.

The Paris key features as follows [TO BE UPDATED]:

- **Security Enhancements**: ONAP projects have addressed critical security
  concerns by converting ports to HTTPS, removing hard-coded passwords,
  enabling Kubernetes pods to operate with non-root privileges, and mitigating
  Common Vulnerabilities and Exposures (CVEs). These measures have
  significantly bolstered the platform’s security. Additionally, by leveraging
  industry-standard/de facto security protocol and mechanisms such as
  Istio Service Mesh and Ingress Gateway, ONAP ensures secure inter- and
  intra-component communications.
- **Platform Modernization**: Components such as the Common Controller Software
  Development Kit (CCSDK), Configuration Persistence Service (CPS), 
  Usecase User Interface (UUI), Portal-NG and Policy Framework were upgraded
  to Java 17. Additionally, various software versions updates ensure that ONAP
  leverages the latest software development frameworks.
- **ONAP Streamlining Evolution**: This initiative makes ONAP components
  modular and independent through interface abstraction, loose coupling and
  CI/CD. As a result, ONAP has evolved into a collection of individual network
  orchestration functions, allowing the industry to pick and choose specific
  components and enabling flexible and dynamic function adoption.
- **Intent-based Declarative and GenAI Solutions**: Supports generative AI
  solutions powered by large language models (LLMs), and includes data service
  enhancements (domain-specific datasets) of Intent-driven networks and
  Model-As-A-Service (MAAS).
- **Industry Standard-Based Network Interface Upgrade**: CCSDK/SDNC now
  supports an RFC8040-compliant network interface.
- **OpenSSF Gold Standard Achievement**: The CPS and Policy Framework projects
  have achieved the Open Source Security Foundation (OpenSSF) Gold Badging
  standard, demonstrating ONAP’s commitment to high-quality, secure, and
  reliable open-source software development.


Documentation Sources
---------------------

The formal ONAP Release Documentation is available
in :ref:`ReadTheDocs<master_index>`.

The `Developer Wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

OpenSSF Best Practice
---------------------

ONAP has adopted the `OpenSSF Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_


Project specific details are in the :ref:`release notes<component-release-notes>`
for each component.

.. index:: maturity

Known Issues and Limitations
----------------------------
Known Issues and limitations are documented in each
:ref:`project Release Notes <component-release-notes>`.
