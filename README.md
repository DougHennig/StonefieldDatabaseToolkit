# Welcome to Stonefield Database Toolkit (SDT)

Stonefield Database Toolkit (SDT) is a powerful tool written by Doug Hennig and sold for over two decades by Stonefield Software Inc. In January 2020, Stonefield Software open sourced SDT, making it available for free to all Microsoft® Visual FoxPro™ developers.

SDT provides database management tools to developers, to assist both during application development and at run-time.

There are three aspects to SDT:

* It enhances the tools VFP provides to manage data objects.

* It provides the ability to define extended properties for database objects and set or obtain the values of these properties at run-time.

* It includes a class library you can add to your applications to provide data management functions at run-time, including recreating indexes, repairing corrupted table and memo headers, and creating and updating table structures at client sites.

By using SDT, you'll gain the following benefits:

* Reduced development time: Why reinvent the wheel? The data-driven routines included with SDT relieve you from writing many of the table maintenance routines that today's sophisticated users demand. Data-driven routines written once can be included in every application you develop without modification. Just add them to the project, call them from somewhere (a menu, a form, or a program), and forget about them.

* Reduced maintenance effort: The term "data-driven" means the data dictionary drives the application. Change the data dictionary, and many aspects of the application automatically adjust without programming.

* Automatic documentation: The Documenting Wizard, which is included with VFP, documents your application files, but is limited in the documentation of your data. SDT can automatically produce high-quality documentation, completely describing your tables and views, their fields, indexes, and extended properties.

SDT comes with complete source code. It can be installed in any directory on your computer or network. Note: if an earlier version of SDT is installed on your computer, you may want to install this version in a different directory to avoid overwriting the previous
version.

You'll find two subdirectories of the directory where you installed the files: 

* SDT: the files specific for SDT.

* SFCOMMON: common files used by all Stonefield products.

The SDT subdirectory contains the following files:

* REINDEX.PRG, REPAIR.PRG, and UPDATE.PRG: wrappers for the SDT Reindex(), Repair(), and Update() methods. See the Tutorial chapter for information on using these programs.

* SDT.APP, SDT.PJX, and SDT.PJT: the SDT developer application and the project files that create it.

* SDT.CHM: the SDT help file.

In addition to these files, you'll find five subdirectories of the SDT subdirectory:

* DBCX: provides documentation for DBCX.

* HTMLHELP: the source for SDT.CHM using West Wind HTML Help Builder.

* SOURCE: source code for the main application (SDT.APP) and the visual class libraries you'll include in your applications.

* TUTORIAL: files for the SDT tutorial.

* UTILITY: useful utility programs and supporting files. See the Utility Functions section in SDT.CHM for information on these utilities.

Note: all source code that comes with SDT was compiled in VFP 9. If you use an earlier version of VFP, you should recompile all files. The simplest way to do this is to open the SDT project in the SDT directory, click on the Build button, check the Recompile All Files option, and choose Rebuild Project.
