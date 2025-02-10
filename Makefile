CXX = g++
TARGET = cpg
BUILD_DIR = build

# Directories for source files
SRC_DIR = src
IMGUI_DIR = imgui
BACKENDS_DIR = backends

# List all the source files with their relative paths
SOURCES = $(SRC_DIR)/main.cpp \
          $(IMGUI_DIR)/imgui.cpp $(IMGUI_DIR)/imgui_demo.cpp $(IMGUI_DIR)/imgui_draw.cpp \
          $(IMGUI_DIR)/imgui_tables.cpp $(IMGUI_DIR)/imgui_widgets.cpp \
          $(BACKENDS_DIR)/imgui_impl_glfw.cpp $(BACKENDS_DIR)/imgui_impl_opengl3.cpp

# Create a list of object files in the build directory (flattened).
# This converts, for example, src/main.cpp → build/main.o
OBJS = $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCES:.cpp=.o)))

UNAME_S := $(shell uname -s)
LINUX_GL_LIBS = -lGL

CXXFLAGS = -std=c++23 -I$(IMGUI_DIR) -I$(BACKENDS_DIR)
CXXFLAGS += -g -Wall -Wformat
LIBS =

ifeq ($(UNAME_S), Linux)
    ECHO_MESSAGE = "Linux"
    LIBS += $(LINUX_GL_LIBS) `pkg-config --static --libs glfw3`
    CXXFLAGS += `pkg-config --cflags glfw3`
    CFLAGS = $(CXXFLAGS)
endif

# The 'all' target builds the final executable inside build/
all: $(BUILD_DIR)/$(TARGET)
	@echo Build complete for $(ECHO_MESSAGE)

# Create the build directory if it doesn't exist.
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Pattern rule for compiling src/*.cpp files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Pattern rule for compiling imgui/*.cpp files
$(BUILD_DIR)/%.o: $(IMGUI_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Pattern rule for compiling backends/*.cpp files
$(BUILD_DIR)/%.o: $(BACKENDS_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<


# Link the final executable
$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)

# Clean removes the entire build directory.
clean:
	rm -rf $(BUILD_DIR)
