# Functions for easy use

# Print 
print_message() {
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local prefix="[MOONPIE]"
  echo -e "$timestamp $prefix ${@:1}"
}

# Check if command installed
check_command_installed() {
  local command_name="$1"
  
  if command -v "$command_name" >/dev/null 2>&1; then
    print_message "$command_name is installed."
  else
    print_message "$command_name is not installed."
    exit 1
  fi
}









