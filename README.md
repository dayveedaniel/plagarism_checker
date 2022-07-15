# plagiarism checker

A plagiarism checker which uses the shingle algorithm to compare files for text similarities. 
Supported file types(.txt , .docx). PDF file type is still under works. 

UI optimised for windows and mac.

Takes list of files as input and shows the percentage similarities a chosen base files to the other files.

Improvements needed
=> rewrite shingles processing and text comparison logic to c or c++ code to improve speed and 
return value through ffi.

=> rewrite extraction of text from .docx and .txt files to isolate(on a different thread) to improve speed

=> add state management(preferably BLoC).
