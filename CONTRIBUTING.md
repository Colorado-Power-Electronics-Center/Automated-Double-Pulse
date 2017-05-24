# Contributing to the Automated Double Pulse Test Project

Thank you for your interest in contributing to the Automated Double Pulse Test Project! There is still significant work to be done on the project and contributions are always welcome. After you've finished reading this document head over to the issues tab to see what currently needs to be done.

# Contribution Guidelines
## Code Format
When writing code please ensure that it is stylistically as similar as possible to the code around it. Standardization will make it easier for the code to be modified in bulk if needed.

## Code Comments
Please include detailed comments in your code so it is clear to others how it works. This is a shared code base so help make sure everyone is on the same page!

## Code Documentation
All code changes must be documented! The code is documented in a series of markdown files that can be found in the [html](html/) directory. Add or Modify these files as necessary. Once the changes are made to the markdown files it is necessary to generate the HTML files used by MATLAB. This can be done by running the python script [Converter.py](html/converter.py). It will pick up new files without any modifications. 