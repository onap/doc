ONAP Blueprint Enrichment
~~~~~~~~~~~~~~~~~~~~~~~~~

The ONAP Beijing release includes four functional enhancements in the
areas of manually triggered scaling, change management, and hardware
platform awareness (HPA). These features required significant community
collaboration as they impact multiple ONAP projects. These features are
applicable to any use case; however, to showcase them in a concrete
manner, they have been incorporated into VoLTE and vCPE blueprints.

Manually Triggered Scaling
^^^^^^^^^^^^^^^^^^^^^^^^^^

Scale-out and scale-in are two primary benefits of NFV. Scaling can be
triggered manually (e.g., by a user or OSS/BSS) or automatically via a
policy-driven closed loop. An automatic trigger allows real-time action
without human intervention, reducing costs and improving customer
experience. A manual trigger, on the other hand, is useful to schedule
capacity in anticipation of events such as holiday shopping. An ideal
scaling operation can scale granularly at a virtual function level (VF),
automate VF configuration tasks and manage the load-balancer that may be
in front of the VF instances. In addition to run-time, this capability
also affects service design, as VNF descriptors need to be granular up
to the VF level.

The Beijing release provides the initial support for these capabilities.
The community has implemented manually triggered scale-out and scale-in
in combination with a specific VNF manager (sVNFM) and demonstrated this
with the VoLTE blueprint. An operator uses the Usecase UI (UUI) project
to trigger a scaleing operation. UUI communicates with the Service
Orchestrator (SO). SO uses the VF-C controller, which in turn instructs
a vendor-provided sVNFM to implement the scale-out action.

We have also demonstrated a manual process to Scale Out VNFs that use
the Virtual Infrastructure Deployment (VID), the Service Orchestrator
(SO) and the Application Controller (APPC) as a generic VNF Manager.
Currently, the process is for the operator to trigger the Scale Out
action using VID, which will request SO to spin up a new component of
the VNF. Then SO is building the ConfigScaleOut request and sending to
APPC over DMaaP, where APPC picks it up and executes the configuration
scale out action on the requested VNF.

Change Management
^^^^^^^^^^^^^^^^^

NFV will bring with it an era of continuous, incremental changes instead
of periodic step-function software upgrades, in addition to a constant
stream of both PNF and VNF updates and configuration changes. To
automatically deliver these to existing network services, the ONAP
community is creating framework to implement change management
functionality that is independent of any particular network service or
use case. Ideally, change management provides a consistent interface and
mechanisms to manage complex dependencies, different upgrade mechanisms
(in-place vs. scale-out and replace), A/B testing, conflict checking,
pre- and post-change testing, change scheduling, rollbacks, and traffic
draining, redirection and load-balancing. These capabilities impact both
design-time and run-time environments.

Over the next several releases, the community will enhance change
management capabilities in ONAP, culminating with a full CI/CD flow.
These capabilities can be applied to any use case; however, specifically
for the Beijing release, the vCPE blueprint has been enriched to execute
a predefined workflow to upgrade the virtual gateway VNF by using
Ansible. An operator invokes an upgrade operation through the VID
interface. VID drives SO, which initiates a sequence of steps such as
VNF lock, pre-check, software upgrade, post-check and unlock. Since
virtual gateway is an L3 VNF, the specific operations are carried out by
the SDN-C controller in terms of running the pre-check, post-check and
upgrade through Ansible playbooks.

Hardware Platform Awareness (HPA)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Many VNFs have specific hardware requirements to achieve their
performance and security goals. These hardware requirements may range
from basic requirements such as number of cores, memory size, and
ephemeral disk size to advanced requirements such as CPU policy (e.g.
dedicate, shared), NUMA, hugepages (size and number), accelerated
vSwitch (e.g DPDK), crypto/compression acceleration, SRIOV-NIC, TPM, SGX
and so on. The Beijing release provides three HPA-related capabilities:

1. Specification of the VNF hardware platform requirements as a set of
   policies.

2. Discovery of hardware and other platform features supported by cloud
   regions.

3. Selection of the right cloud region and NFV infrastructure flavor by
   matching VNF HPA requirements with the discovered platform
   capabilities.

While this functionality is independent of any particular use case, in
the Beijing release, the vCPE use case has been enriched with HPA. An
operator can specify engineering rules for performance sensitive VNFs
through a set of policies. During run-time, SO relies on the ONAP
Optimization Framework (OOF) to enforce these policies via a
placement/scheduling decision. OOF determines the right compute node
flavors for the VNF by querying the above-defined policies. Once a
homing decision is conveyed to SO, SO executes the appropriate workflow
via the appropriate controller.
