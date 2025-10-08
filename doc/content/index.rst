.. image:: ../images/otobo-logo.png
   :align: center

.. toctree::
    :maxdepth: 2
    :caption: Contents

Overview
========
Summary
-------
This package enhances the Generic Agent Job Management functionality with the ability to use special field tags (e.g., <OTOBO_AGENT_SUBJECT>, <OTOBO_AGENT_BODY>, etc.). Tags are acceptable in the following sections and fields:

**Update/Add Ticket Attributes**  

* New customer user ID
* New customer ID
* New title
* Any dynamic field of type Text, RichText, or TextArea

**Add note**  

* From
* Subject
* Text

Acceptable field tags:

**OTOBO_CUSTOMER_REALNAME**

To get the name of the ticket's customer user (if given).

**OTOBO_CUSTOMER_DATA_**

Attributes of the current customer user data
( e. g.") OTOBO_CUSTOMER_DATA_UserFirstname

**OTOBO_OWNER_* or OTOBO_TICKET_OWNER_***

Attributes of the current ticket owner user data
( e. g.") OTOBO_OWNER_UserFirstname, OTOBO_TICKET_OWNER_UserFirstname

**OTOBO_***

Attributes of the recipient user for the notification
( e. g.") OTOBO_UserFullname&gt or OTOBO_NOTIFICATION_RECIPIENT_UserFullname

**OTOBO_TICKET_**

Attributes of the ticket data
( e. g.") OTOBO_TICKET_TicketNumber, OTOBO_TICKET_TicketID, OTOBO_TICKET_Queue, OTOBO_TICKET_State

**OTOBO_TICKET_DynamicField_**

Ticket dynamic fields internal key values
( e. g.") OTOBO_TICKET_DynamicField_TestField, OTOBO_TICKET_DynamicField_TicketFreeText1

**OTOBO_TICKET_DynamicField_\*_Value**

Ticket dynamic fields display values, useful for Dropdown and Multiselect fields
( e. g.") OTOBO_TICKET_DynamicField_TestField_Value

**OTOBO_CONFIG_**

Config options
( e. g.") OTOBO_CONFIG_HttpType


Configuration
=============

System requirements
-------------------

Framework
^^^^^^^^^
OTOBO 11.0.x

Packages
^^^^^^^^
Not applicable

Third-party software
^^^^^^^^^^^^^^^^^^^^
Not applicable

Basic Configuration
-------------------
Open the Package Manager module from the Administration group in the Agent Interface. Select the package named GenericAgent-NotificationTags from the Online Repository. Click the associated  *Install* link on that line and respond affirmatively to any confirmation questions that follow.

Custom Configuration and Advanced Features
------------------------------------------
Not applicable

Configuration Reference
-----------------------
Not applicable

About
=======

Contact
-------
| Rother OSS GmbH
| Email: hello@otobo.io
| Web: https://otobo.io

Version
-------
Author: |doc-vendor| / Version: |doc-version| / Date of release: |doc-datestamp|
