# README

The readme covers the flow of using TCAD, what files are (to some extent), where
files were generated, what commands to run.

The server running TCAD is `precision.cqct.unsw.edu.au`.

## Quadropole Field Gradient/SET Structure

Based on a simple SET used by Henry and Fahd. The SET is two layers, with two
gates added next to the dot two introduce a field gradient.

See the ![layout sketch][layout] for more information.

[layout]: ./layout.jpg

## Files

Initially

1. mosQD4.7.par - parameter file (supplied) for all relevant materials.
2. structure.scm - structrue/doping/refinement(grid size)/contacts are defined.
3. settings_des.cmd - gate voltages/temperature/equations to be solved. other
   input files for DESSIS are specified here

Generate (note that I define quad as the basename in sturcture.scm and
settings_des.cmd):

1. Run DEVISE: quad.cmd, quad.bnd, quad.sat, quad.scm, devise.jrl
2. Run MESH: quad_msh.grd, quad_msh.dat, quad_msh.log
3. Run DESSIS: quad_des.plt, quad_des.dat, quad_des.log

## TCAD Flow

Henry''s thesis also describes the flow of TCAD. Fahd is the resisdent expert.

1. Create structure as a DEVISE scheme script
    * (ise:save-model "NAME") determines output
2. Generate boundary and mesh command file in DEVISE (and view if you want):
    * `devise -e -l structure.scm`
    * Output: NAME.bnd, NAME.cmd, NAME.sat, NAME.scm, devise.jrl
3. Create mesh file
    * `mesh -P NAME`
    * Input: NAME.bnd, NAME.cmd
    * Output: grid file (NAME_msh.grd), doping file (NAME_msh.dat), log for grid
      generation (NAME_msh.log)
4. Solve equations:
    * `dessis settings_des.cmd`
    * Main input: command file (settings_des.cmd)
    * Other inputs: grid (.grd), doping (.dat), parameter file (.par)
    * Output: plot (.plt), data (.dat)
5. View results
    * `tecplot_ise NAME_des.dat NAME_msh.grd`

## Notes on File Types

See the manuals for more information. This is a list of output files from the
different programs.

DESSIS:

* `scm` - Scheme script file. Used by Devise.
* `sat` - ASCII version of complete model.
* `cmd` - MESH command file. Doping and refinement file.
* `bnd` - DF-ISE boundary representation.

MESH:
In general mesh files should have 'msh' somewhere in their name.

* `grd`: output device geometry file
* `dat`: output impurity concentration file

DESSIS:
In general dessis files should have 'des' somewhere in their name.

* `_des.dat`: output data for TECPLOT
* `_des.plt`: output for current, voltages, charges, and temperature
* `_ac_des.plt`: output for small signal AC analysis
* `_des.log`: general output. plain text compilation of all output.

TECPLOT:

* `grd` - input mixed-element grid from MESH
* `dat` - input mixed-element data from DESSIS
* `plt` - XY plots from desis from DESSIS

## Note from Fahd

Right now the work function of aluminium is set at 4.7 in the parameter file, to
take into account charges indirectly at the Si/SiO2 interface of our devices.
But ideally, it is ~4.28. If you change the work function in the parameter file,
you also have to add interface charges manually in the potential file
(SD201_pot.cmd). I can help you with that later on.

Also note that the line commenting character in "SD201_mod.cmd" is ";" and
"SD201_pot.cmd" is "#".
