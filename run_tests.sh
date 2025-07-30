#!/bin/bash

# Test runner script for Jenga App
# This script runs all the tests in the project

echo "🧪 Running Jenga App Tests"
echo "=========================="

# Navigate to project directory
cd "$(dirname "$0")"

echo "📱 Running Flutter tests..."

# Run all tests
flutter test

# Check if tests passed
if [ $? -eq 0 ]; then
    echo "All tests passed!"
    echo ""
    echo "Test Summary:"
    echo "- Widget Tests:"
    echo "- Unit Tests:"
    echo "- Model Tests:"
    echo "- Utility Tests:"
    echo "- Integration Tests:"
    echo ""
else
    echo "Some tests failed. Please check the output above."
    exit 1
fi
