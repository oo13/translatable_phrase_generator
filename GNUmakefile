#!/usr/bin/gmake -f
#
# This plugin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This plugin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this plugin.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright © 2024 OOTA, Masato

MODNAME=endless_names_mod
PODIR=po
LANGS=$(shell cat $(PODIR)/LINGUAS)
POTFILES=$(PODIR)/POTFILES.in
LUA=$(shell cat $(POTFILES))
GETTEXTDIR=gettext
POTFILE=$(PODIR)/$(MODNAME).pot
MOFILES=$(LANGS:%=$(GETTEXTDIR)/%/LC_MESSAGES/$(MODNAME).mo)

pot: $(POTFILE)
mo: $(MOFILES)


$(POTFILE): $(XML) $(LUA) $(PODIR)/its/* $(PODIR)/LINGUAS $(POTFILES)
	GETTEXTDATADIR=$(PODIR) xgettext -f $(POTFILES) -D . --from-code=utf-8 -o $@
	@echo Create $(LANGS:%=\"$(PODIR)/%.po\") from \"$@\", and then run \"make mo\".


$(GETTEXTDIR)/%/LC_MESSAGES/$(MODNAME).mo: $(PODIR)/%.po
	mkdir -p $(dir $@)
	msgfmt $^ -o $@

clean:
	-rm $(POTFILE) $(MOFILES)
