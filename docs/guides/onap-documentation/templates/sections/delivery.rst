.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2021 ONAP contributors, Nokia

Delivery
========

..
   * This section is used to describe the delivery of a software component.
     For a run-time component, this might be executable images, containers, etc.
     For an SDK, this might be libraries.

   * This section is typically provided for a platform-component and sdk;
     and referenced in developer and user guides.

Process
-------
..
  If needed, describe the steps of the delivery pictured on the block diagram.

.. blockdiag::


    blockdiag layers {
      orientation = portrait
      a -> m;
      b -> n;
      c -> x;
      m -> y;
      m -> z;
      group l1 {
        shape = line;
        color = "#07819B";
        x; y; z;
        }
    group l2 {
      shape = line;
      color = "#1a3d6f";
      m; n;
    }
    group l3 {
      shape = line;
      color = "#5dbeba";
      a; b; c;
    }

    }

Deliverables
------------

..
  List the deliverables in the package here.
