.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

ONAP 'Jakarta' Release Notes
============================

This page provides the release notes for the ONAP 'Jakarta' release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

Jakarta Major Release 10.0.0
----------------------------

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Jakarta                              |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 10.0.0                               |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2022, June 30th                      |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Features
^^^^^^^^
ONAP Jakarta focusses on:

- Security enhancements in the A&AI, CCSDK, MSB, and MultiCloud projects,
  reducing log4j vulnerability and removing most GPLv3 dependencies
- Deepened O-RAN integration in the OOF SON and CCSDK projects with O-RAN O1
  models and the O-RAN AI Policy interface (consumed downstream by the O-RAN
  Software community)
- Enabling a richer set of day-2 configuration for Cloud-Native Network
  Functions (CNF) through CDS API extensions
- Intent based networking (IBN) for closed loop for E2E Network Slicing
- New functionality in the Configuration Persistence Service (CPS) that allows
  more granular control of configuration-heavy network services like RAN
- Simplification of control loop automation architecture, enabling easy
  deployment of new control modules
- New Network Function lifecycle management features based on real-life use
  cases
- Modeling: Solidified the data model for CNFs using the novel Application
  Service Descriptor (ASD) approach, while continuing alignment with data
  models produced by SDOs such as ETSI
- An overhaul of the policy framework allowing easy composition of control
  loop policies and better observability
- Continued 5G Super Blueprint integrations, including EMCO, Magma 1.6, Anuket
  and KubeRef RI2

Functional Requirements
^^^^^^^^^^^^^^^^^^^^^^^

Increased Cloud Native Functionality
""""""""""""""""""""""""""""""""""""

- Improved synchronization of k8s resources after the creation of the CNF.
  When some change occurs for the CNF in the k8s cluster, k8splugin sends
  a notification to the cnf-adapter which performs an update of the changes
  into A&AI.
- CDS integration with k8splugin

  - The creation of the profile allows the specification of labels and
    additional k8sresource types to be returned by the status API
  - Better Configuration API support including rollback, improved deletion
    of the configuration with or without removal of the configuration
    resources in the cluster
  - Creation of the configuration template without a dedicated helm chart
    which allows for easy update of the override values by configuration API
    without a need to duplicate configuration template helm chart from the
    main Helm chart. The configuration template (Helm chart) is taken from
    the main definition.

- New model for CNF modeling: Application Service Descriptor (ASD) model

E2E Network Slicing
"""""""""""""""""""

- CPS Integration with SDN-R for RAN Slice allocate and reconfigure scenarios
- E2E network Slicing with CPS is completed for allocation and re-use scenarios
- E2E Closed loop with CPS is functional
- IBN based closed loop with ML MS (POC) and Config DB is functional
- Optimization of cm-handle registration with CPS-DMI Plugin to upload yang
  model
- CPS Integration Stabilization for RAN Slice activate/deactivate  scenarios
- Addition of call to OOF for allocateNSSI to enable TN NSSI reuse in TN NSSMF
- Addition of call to OOF for terminateNxi API to deallocate NSSI
  (without terminating TN NSSI even when NSI is terminated) in TN NSSMF
- Closed-loop enhancement in CCVPN to support Transport Slicing’s closed-loop

Control Loop evolutions
"""""""""""""""""""""""

- Control Loop in TOSCA LCM Improvement: abstract Automation Composition
  Management (ACM) logic with a generic Automation Composition definition,
  isolating Composition logic from ONAP component logic. It elaborates APIs
  that allow integrate with other design systems as well as 3PP component
  integration.
- The current PMSH and TCS control loops are migrated to use an Automation
  Composition approach. Support for Automation Compositions in SDC is also
  introduced.
- A Metadata set allows a global set of metadata containing rules or global
  parameters that all instances of a certain policy type can use. Metadata
  sets are introduced in the Policy Framework in the Jakarta release. This
  means that different rule set implementations can be associated with a
  policy type, which can be used in appropriate situations.
- Introduction of Prometheus for monitoring Policy components so that
  necessary alerts can be easily triggered and possible outages can be
  avoided in production systems.

  - Expose application level metrics in policy components. An end user can
    plug in a Prometheus instance and start listening to the metrics exposed
    by Policy components and either raise alerts or show them on a Grafana
    dashboard for operations team to keep monitoring the health of the system.
  - Improve the policy/api and policy/pap readiness probes to handle database
    failures so that the policy/api and policy/pap kubernetes pods are marked
    ready only if the Policy database pod is ready.
  - Provide sample Grafana dashboards for policy metrics

- Migration of Policy Framework components to Springboot to support easier
  handling, configuration and maintenance.
- Policy Framework Database Configurability. The Policy Framework can be
  configured to use any JDBC-compliant RDBMS and configuration files are
  supplied for the Postgres RDBMS. MariaDB remains the default RDBMS for the
  Policy Framework in ONAP
- System Attribute Improvements

  - Transaction boundaries on REST calls are implemented per REST call
  - JDBC backend uses Spring and Hibernate rather than Eclipselink
  - All GUIs are now included in the policy/gui microservice
  - Documentation is rationalized and cleaned up, testing documentation is
    now complete
  - Scripts are added to make release of the Policy Framework easier

Fault management
""""""""""""""""

- DCAE Helm Transformation finalized
- Topic alignment for DCAE microservices:  use standard topics for PM-Mapper,
  Slice-Analysis and KPI-MS

Extended O-RAN Integration
""""""""""""""""""""""""""

- The O-RAN A1 interface (from the CCSDK project) provides a flexible way for
  RAN operators to manage wide area RAN network optimization
- Enhanced A1 interface controller and A1 Policy capabilities are now usable
  by any service provider deploying and using ONAP. This functionality is used
  downstream in the O-RAN-SC Non-RealTime RIC project
- The OOF SON project has updated the SDN-R to use O-RAN aligned O1 YANG models
  and the RAN-Sim to use O-RAN aligned O1 YANG models
- Convergence on VES message formats for Performance Management,
  Fault Management, Configuration Management


Controllers
"""""""""""

- SDN-C is upgraded to OpenDaylight Phosphorus release
- Enhancements to CCVPN, Network Slicing, and ONAP A1 Interface

Service Design
""""""""""""""

- Improved support for TOSCA features
- Automation Composition Management model
- Support for large CSAR via S3 storage

Inventory
"""""""""

- Schema updated for CCVPN use case mainly enhancing and bug fixes of the Cloud
  Leased Line (CLL) service

ONAP Operations Manager
"""""""""""""""""""""""

- Introduction of Strimzi Kafka Operator
- Migration of all Kafka native clients to use Strimzi Apache Kafka.
- Disable VID, Portal

Non-Functional Requirements
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following 'non-functional' requirements are followed in the
Jakarta Release:

Best Practice
"""""""""""""

- ONAP shall use STDOUT for logs collection
- IPv4/IPv6 dual stack support in ONAP
- Containers must crash properly when a failure occurs
- Containers must have no more than one main process
- Application config should be fully prepared before starting the
  application container
- No root (superuser) access to database from application container

Code Quality
""""""""""""

- Each ONAP project shall improve its CII Badging score by improving input
  validation and documenting it in their CII Badging site
- Each ONAP project shall define code coverage improvements and achieve at
  least 55% code coverage

Security
""""""""

- Python language 3.8
- Java language v11
- All containers must run as non-root user
- Continue hardcoded passwords removal
- Flow management must be activated for ONAP
- Each project updates the vulnerable direct dependencies in their code base
- Pilot for automating the creation of a Software Bill of Materials (SBOM).
  Tools for automated SBOM creation are now rolled into the CI chain of ONAP

Documentation
"""""""""""""

- Documentation cleaned up. Chapters which include unmaintained projects were
  removed to avoid misunderstandings at the readership
- Projects (repositories) which do not create a stable release branch are no
  longer included in the release documentation. This should help to improve the
  release management process
- Beginning with this release we are providing example configuration files for
  setting up a proper process of documentation creation
- The Interactive Architecture Overview is updated
- The guide to set up a development system for documentation is updated

Tests & Integration
"""""""""""""""""""

- Create Java and Python base images
- Adapt robot tests to DCAE project changes: Cloudify to Helm migration
- New test: basic_cnf_macro
- Release ONAP data provider tool
- Automate repositories INFO.yaml updates

.. important::
   Some non-functional requirements are not fully finalized. Please, check details
   on the :doc:`Integration<usecases/release_non_functional_requirements>`

Documentation Sources
^^^^^^^^^^^^^^^^^^^^^

The formal ONAP 'Jakarta' Release Documentation is available
in :ref:`ReadTheDocs<master_index>`.

The `Developer Wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

CII Best Practice
^^^^^^^^^^^^^^^^^

ONAP has adopted the `CII Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

In the Jakarta release,

- 100% projects passed 90% of the CII badge
- 85% projects passed the CII badge
- 11% projects passed the CII Silver badge

Project specific details are in the :ref:`release notes<doc-releaserepos>` for
each project.

.. index:: maturity

ONAP Maturity Testing Notes
^^^^^^^^^^^^^^^^^^^^^^^^^^^
For the Jakarta release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

In Jakarta the Integration team focussed in

- Automating ONAP Testing to improve the overall quality
- Adding security and E2E tests

More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Known Issues and limitations are documented in each
:ref:`project Release Notes <doc-releaserepos>`.
