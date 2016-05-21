# Simple Project Planner / Coordinator

The purpose of this Drupal web application is to provide a flexible online
environment for developing a shared platform for IT departments to share and
report information about current and planned projects, so that everyone can
see what is going on across the organization and people who need to be involved
in major project changes can be notified when changes are made.


## Scope

Right now to keep things very simple for a MVP this serves two basic functions:

1. Provide a database and user friendly interface for inventorying and funding
current and future projects.  This is meant to replace quickly outdated
spreadsheets and diagrams.

2. Provide a means of getting updated to the projects that are currently
happening or are in planning phases that we care about


## Architecture

This is a PHP web platform built on Drupal 8.  Drupal was chosen because it
provides an easy means of exploring and editing things, such as what project
fields might be tracked over time or managing access without requiring software
updates and deployments.

The primary features:
 * Create and update projects
 * List, filter, and export project information
 * Subscribe to notifications when projects are created, updated, or removed

Since this is a prototype and meant to be a starting point, there has been
little focus on creating custom modules are themes.  If this proves a useful
tool then that can be improved over time.

This portal is built for deployment to https://cloud.gov.  See INSTALL.md for
more information about how to install yourself into cloud.gov or Cloud Foundry.
