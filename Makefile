prefix=/usr/local/g2

# files that need mode 755
CMDS_FILES=`ls cmds/*.sh`

SETUPFILES =g2-config.sh
SETUPFILES+=g2-install.sh

# files that need mode 644
SCRIPT_FILES =g2-completion.sh
SCRIPT_FILES+=g2-prompt.conf
SCRIPT_FILES+=g2-prompt.sh
SCRIPT_FILES+=g2.sh

all:
	@echo "usage: make install"
	@echo "       make uninstall"

install:
	install -d -m 0755 $(prefix)/cmds
	install -m 0755 $(CMDS_FILES) $(prefix)/cmds
	install -m 0755 $(SETUPFILES) $(prefix)
	install -m 0644 $(SCRIPT_FILES) $(prefix)

#uninstall:
#	rm -rf $(prefix)

