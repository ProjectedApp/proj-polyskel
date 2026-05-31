#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# 1. Clean up old build artifacts so you don't accidentally re-upload old versions
echo "Cleaning up old builds..."
rm -rf build/ dist/ *.egg-info

# 2. Make sure build tools are up to date
echo "Updating build tools..."
python3 -m pip install --upgrade build twine

# 3. Build the package
echo "Building package (Source and Wheel)..."
python3 -m build

# 4. Ask the user where to upload
echo "Where do you want to upload?"
select target in "TestPyPI" "Production-PyPI" "Cancel"; do
    case $target in
        "TestPyPI" )
            echo "Uploading to TestPyPI..."
            python3 -m twine upload --repository testpypi dist/*
            break
            ;;
        "Production-PyPI" )
            echo "UPLOADING TO LIVE PYPI"
            read -p "Are you absolutely sure? (y/N) " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                python3 -m twine upload dist/*
            else
                echo "Upload aborted."
            fi
            break
            ;;
        "Cancel" )
            echo "Upload cancelled. Your build files are ready in dist/"
            exit 0
            ;;
    esac
done

echo "Done!"