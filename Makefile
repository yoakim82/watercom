# Generic Makefile (c) 2013 Jörg Seebohn
# Use it at your own risk !
# This Makefile depends on GNU make.

# The clean command uses "@echo rm -rf $(TargetDir)"
# remove the echo if you know that $(TargetDir) is set to a valid value.
# Adapt project specific part to your own project.
# Adapt compile specific part to your own compiler.
# Compiler gcc is preconfigured.

# Mode specific values are added after the mode agnostic values.
# The generated binary is stored as $(TargetDir)/$(Project)_$(buildmode)
# You can change the location by changing TargetFilename
# The object files are stored in directory $(TargetDir)/$(buildmode)/$(Project)
# You can change the location by changing ObjectFilename
# Variable "Modes" contains the list of build modes. Add your own mode with "Modes += mymode" if you like and add
# additional compiler and linker flags with "CFlags_mymode := " and "LFlags_mymode := ".

#########################
# Project Specific Part #
#########################
Project := watercom
Modes   := debug release

# Directory where target binary is created and object files
TargetDir         := bin
# Search Path For Include Files (InclPaths is included before mode specific InclPaths_MODE)
InclPaths         :=/usr/local/include
InclPaths         +=/usr/include
InclPaths_Debug   :=
InclPaths_Release :=
# Defined values used by C preprocessor (Defines is included before mode specific Defines_MODE)
Defines           := KONFIG_SUBSYS=none
Defines_Debug     := DEBUG
Defines_Release   := RELEASE
# List of Library Names (Libs is included before mode specific Libs_MODE)
Libs              :=bcm2835 wiringPi
Libs_Debug        :=
Libs_Release      :=
# Search Paths for Libraries (LibPaths is included before mode specific LibPaths_MODE)
LibPaths          :=/usr/local/lib
LibPaths_Debug    :=
LibPaths_Release  := 
# Compiler specific flags (CFlags is included before mode specific CFlags_MODE)
CFlags            := -std=gnu1x -pedantic -Wall -Wextra -Wconversion -Wshadow -Wcast-qual -Wwrite-strings  -Wformat-nonliteral -Wformat-y2k 
CFlags_Debug      := -g
CFlags_Release    := -O2
# Linker specific flags (LFlags is included before mode specific LFlags_MODE)
LFlags            :=
LFlags_Debug      := -g
LFlags_Release    := -O2

# Add Your Source file here
# Use $(wildcard dir/*.c) if you want to include files from directory 'dir'
#Src := $(wildcard src/*.c)
Src := src/spi.c
Src += src/gpio.c
Src += src/rfm22.c
Src += src/aircom.c
Src += src/dbconnect.c
#Src += C-kern/context/errorcontext.c
#Src += C-kern/context/maincontext.c
#Src += C-kern/context/processcontext.c
#Src += C-kern/context/threadcontext.c
#Src += C-kern/cache/objectcache_impl.c
#Src += C-kern/cache/valuecache.c
#Src += C-kern/ds/inmem/blockarray.c
#Src += C-kern/ds/inmem/dlist.c
#Src += C-kern/ds/inmem/queue.c
#Src += C-kern/memory/pagecache_impl.c
#Src += C-kern/memory/mm/mm_impl.c
#Src += C-kern/task/syncqueue.c C-kern/task/syncrun.c C-kern/task/syncwlist.c
#Src += C-kern/io/writer/errlog.c C-kern/io/writer/log/logmain.c
#Src += C-kern/platform/Linux/locale.c
#Src += C-kern/platform/Linux/vm.c
#Src += C-kern/platform/Linux/io/file.c

##########################
# Compiler Specific Part #
##########################
IncPathFlag := -I
DefineFlag  := -D
LibraryFlag := -l
LibPathFlag := -L
# -MMD flag let gcc generate a dependency file "objectfilename.d" in addition to the object file "objectfilename.o"
CC          := gcc -MMD
LD          := gcc

#########################
# Generic Template Part #
#########################
all: $(Modes)

clean:
	@echo clean: $(Project)
	@echo rm -rf $(TargetDir)

$(Modes:%=clean_%):
	@echo rm -rf $(TargetDir)/$(subst clean_,,$@)/$(Project)/

$(Modes:%=init_%):
	@mkdir -p $(TargetDir)/$(subst init_,,$@)/$(Project)

define TargetFilename
$(TargetDir)/$(Project)_$(1)
endef

define ObjectFilename
$(TargetDir)/$(1)/$(Project)/$(subst /,!,$(2)).o
endef

define CompileObject
$(call ObjectFilename,$(1),$(2)): $(2)
	@echo cc: '$$<'
	@$$(CC_$(1)) -c -o '$$@' '$$<'
endef

define TargetTemplate
CC_$(1) := $(CC) $(Defines:%=$(DefineFlag)%) $$(Defines_$(1):%=$(DefineFlag)%) $(InclPaths:%=$(IncPathFlag)%) $$(InclPaths_$(1):%=$(IncPathFlag)%) $(CFlags) $$(CFlags_$(1)) $(shell mysql_config --cflags --libs)

Objects_$(1)  := $(foreach file,$(Src),$(call ObjectFilename,$(1),$(file)))

$(1):	init_$(1) $(call TargetFilename,$(1))

$(call TargetFilename,$(1)): $$(Objects_$(1))
	@echo ld: '$$@'
	@$(LD) $(LFlags) $$(LFlags_$(1)) -o '$$@' $$(^:%='%') $(LibPaths:%=$(LibPathFlag)%) $$(LibPaths_$(1):%=$(LibPathFlag)%) $(Libs:%=$(LibraryFlag)%) $$(Libs_$(1):%=$(LibraryFlag)%) $(shell mysql_config --cflags --libs)

$(foreach file,$(Src),$(eval $(call CompileObject,$(1),$(file))))

# Include compiler generated dependency files
-include $$(Objects_$(1):.o=.d)

endef

$(foreach mode,$(Modes),$(eval $(call TargetTemplate,$(mode))))
