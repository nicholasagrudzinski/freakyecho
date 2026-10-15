all: freakyecho
.PHONY: all clean install install-global remove

# Compiler and flags
CC := gcc
CFLAGS := -g

# Variables
SRC := freakyecho.c
TARGET := freakyecho

# Target directories
GLOBAL_INSTALL_DIR = /usr/bin

# remove is ran with sudo, so recover real name
# tries logname
# on failure, assumes user is running this makefile in their home directory
REAL_USER := $(shell u=$$(logname 2>/dev/null); if [ -n "$u" ]; then echo "$$u"; else stat -c '%U' .; fi)

LOCAL_INSTALL_DIR = /home/$(REAL_USER)/.local/bin

# Build the target
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) 

install: $(TARGET)
	@echo "Installing to $(LOCAL_INSTALL_DIR)"
	mkdir -p $(LOCAL_INSTALL_DIR)
	cp $(TARGET) $(LOCAL_INSTALL_DIR)/$(TARGET)

install-global: $(TARGET)
	@echo "Installing to $(GLOBAL_INSTALL_DIR)"
	cp $(TARGET) $(GLOBAL_INSTALL_DIR)/$(TARGET)

remove: clean
	@echo "Removing binaries for user: $(REAL_USER):"
	rm -f "$(LOCAL_INSTALL_DIR)/$(TARGET)"
	@if [ "$$(id -u)" -eq 0 ]; then \
		echo "Removing global install."; \
		rm -f "$(GLOBAL_INSTALL_DIR)/$(TARGET)"; \
	else \
		echo "Run with sudo to uninstall from $(GLOBAL_INSTALL_DIR)"; \
	fi


# Clean build artifacts
clean:
	rm -f $(TARGET)
