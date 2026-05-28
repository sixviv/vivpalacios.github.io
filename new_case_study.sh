#!/bin/bash
# Usage: ./new_case_study.sh "Company Name" "optional-password"
# Example: ./new_case_study.sh "Google Cloud" "mypassword123"

set -e

if [ -z "$1" ]; then
  echo "Usage: ./new_case_study.sh \"Company Name\" \"password\""
  exit 1
fi

COMPANY="$1"
SLUG=$(echo "$COMPANY" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
DIR="case-studies/$SLUG"

if [ -d "$DIR" ]; then
  echo "Error: $DIR already exists."
  exit 1
fi

# Generate password hash
if [ -n "$2" ]; then
  PASS="$2"
else
  PASS="vivpalacios2026"
fi
HASH=$(echo -n "$PASS" | shasum -a 256 | awk '{print $1}')

# Scaffold from template
mkdir -p "$DIR"
cp case-studies/_template/index.html "$DIR/index.html"

# Replace company name placeholder and password hash
sed -i '' "s/Couchsurfing/$COMPANY/g" "$DIR/index.html"
sed -i '' "s/couchsurfing-host-availability-is-down/$SLUG/g" "$DIR/index.html"
sed -i '' "s/b556f4213c1c15d90509bb36d5cbb80eda7bf24fbd7367dcaa677711d4427afb/$HASH/" "$DIR/index.html"

echo ""
echo "Created: $DIR/index.html"
echo "URL:      https://sixviv.github.io/case-studies/$SLUG"
echo "Password: $PASS"
echo ""
echo "Edit $DIR/index.html to fill in your case study content."
echo "Then: git add $DIR && git commit -m \"Add $COMPANY case study\" && git push"
