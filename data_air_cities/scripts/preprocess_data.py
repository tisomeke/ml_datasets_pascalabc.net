#!/usr/bin/env python3
"""
Preprocessing script for Air Cities dataset.

This script documents the steps taken to convert the raw data from
tochno-st/air_quality_cities into the educational dataset format
compatible with ML PascalABC.NET.

Steps performed:
1. Download air_cities.csv from tochno-st/air_quality_cities repository
2. Convert delimiter from ';' to ',' with proper CSV quoting
3. Ensure UTF-8 encoding, LF line endings
4. Create a 1000-row sample for quick experimentation

Requirements: Python 3.6+, no external dependencies (uses only csv, os)
"""

import csv
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


def convert_delimiter(input_filename, output_filename):
    """
    Convert semicolon-delimited CSV to comma-delimited CSV.
    
    Fields containing commas are automatically quoted by csv.writer
    with QUOTE_MINIMAL strategy.
    
    Args:
        input_filename: Path to source CSV (semicolon delimiter)
        output_filename: Path to output CSV (comma delimiter)
    """
    with open(input_filename, 'r', encoding='utf-8', newline='') as infile:
        reader = csv.reader(infile, delimiter=';')
        with open(output_filename, 'w', encoding='utf-8', newline='') as outfile:
            writer = csv.writer(outfile, delimiter=',', quoting=csv.QUOTE_MINIMAL)
            for row in reader:
                writer.writerow(row)
    print(f'Converted: {input_filename} -> {output_filename}')


def create_sample(input_filename, output_filename, n_rows=1000):
    """
    Create a smaller sample of the dataset.
    
    Args:
        input_filename: Path to full CSV
        output_filename: Path to sample CSV
        n_rows: Number of data rows to include (default: 1000)
    """
    with open(input_filename, 'r', encoding='utf-8', newline='') as infile:
        reader = csv.reader(infile)
        header = next(reader)
        with open(output_filename, 'w', encoding='utf-8', newline='') as outfile:
            writer = csv.writer(outfile)
            writer.writerow(header)
            for i, row in enumerate(reader):
                if i >= n_rows:
                    break
                writer.writerow(row)
    print(f'Sample created: {output_filename} ({n_rows} rows)')


if __name__ == '__main__':
    # Step 1: Download from source (requires internet)
    # curl -sL "https://raw.githubusercontent.com/tochno-st/air_quality_cities/main/data/air_cities.csv"
    
    # Step 2: Convert delimiter
    convert_delimiter(
        os.path.join(DATA_DIR, 'data_air_cities_raw.csv'),
        os.path.join(DATA_DIR, 'data_air_cities_raw.csv')
    )
    
    # Step 3: Create sample
    create_sample(
        os.path.join(DATA_DIR, 'data_air_cities_raw.csv'),
        os.path.join(DATA_DIR, 'data_air_cities_sample_1000.csv')
    )
    
    print('Done.')