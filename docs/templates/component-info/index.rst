.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0

Component Information Template
==============================
High level architecture, design, and packaging information for release planning and delivery.

.. toctree::
   :maxdepth: 1


Delivery
--------
Th package component is composed of the functional layers and packaged into run-time components as illustrated in the following diagrams.

.. blockdiag::
   

   blockdiag layers {
   orientation = portrait
   a -> m;
   b -> n;
   c -> x;
   m -> y;
   m -> z;
   group l1 {
	color = blue;
	x; y; z;
	}
   group l2 {
	color = yellow;
	m; n; 
	}
   group l3 {
	color = orange;
	a; b; c;
	}

   }


Offered APIs
------------

.. csv-table:: 
   :header-rows: 0
   :header: "Container or Library", "API Reference", "Purpose", "Protocol", "Port", "TCP/UDP"
   :widths: 20, 25, 25, 10, 10, 10
   :delim: |
   :file: offered-apis.csv


Consumed APIs
-------------

.. csv-table:: 
   :header-rows: 0
   :header: "Project Repo/Group ID", "Container or Library Offering API"
   :widths: 30, 30
   :delim: |
   :file: consumed-apis.csv

Logging & Diagnostic Information
--------------------------------
Description of how to interact with and diagnose problems with the components in the run-time packaging.


Installation
------------
Steps to Install


Configuration
-------------
Where are they provided?
What are parameters and values?


Administration
--------------

How to run and manage the component.


Human Interfaces
----------------
Basic info on the interface type, ports/protocols provided over, etc.



