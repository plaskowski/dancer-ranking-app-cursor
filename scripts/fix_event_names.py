#!/usr/bin/env python3
"""
Script to fix event JSON files by adding default names to events missing them.
This allows importing historical event data even when event names are missing.

Usage:
    python scripts/fix_event_names.py input_file.json output_file.json
    python scripts/fix_event_names.py input_file.json  # overwrites input file
"""

import json
import sys
import os
from datetime import datetime
from typing import Dict, List, Any


def format_date_for_name(date_str: str) -> str:
    """Convert date string to a readable format for event names."""
    try:
        date_obj = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
        return date_obj.strftime('%B %d, %Y')  # e.g., "January 15, 2024"
    except:
        return date_str  # fallback to original string


def fix_event_names(data: Dict[str, Any]) -> Dict[str, Any]:
    """Fix events by adding default names where missing."""
    if 'events' not in data:
        return data
    
    events = data['events']
    fixed_events = []
    
    for i, event in enumerate(events):
        if not isinstance(event, dict):
            print(f"Warning: Event {i} is not a valid object, skipping")
            continue
            
        # Check if name is missing, null, or empty
        name = event.get('name')
        if not name or (isinstance(name, str) and name.strip() == ''):
            # Generate default name based on date
            date_str = event.get('date', 'Unknown Date')
            default_name = f"Event on {format_date_for_name(date_str)}"
            
            print(f"Event {i}: Adding default name '{default_name}'")
            event['name'] = default_name
        else:
            print(f"Event {i}: Name already present '{name}'")
            
        fixed_events.append(event)
    
    data['events'] = fixed_events
    return data


def main():
    if len(sys.argv) < 2:
        print("Usage: python scripts/fix_event_names.py input_file.json [output_file.json]")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else input_file
    
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found")
        sys.exit(1)
    
    try:
        # Read input file
        print(f"Reading {input_file}...")
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Fix event names
        print("Fixing event names...")
        fixed_data = fix_event_names(data)
        
        # Write output file
        print(f"Writing to {output_file}...")
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(fixed_data, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Successfully fixed event names in {output_file}")
        
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in {input_file}: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main() 