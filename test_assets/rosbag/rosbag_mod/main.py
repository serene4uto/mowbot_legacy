#!/usr/bin/env python3
"""
This script reads a ROS2 bag, modifies the `header.frame_id` of:
  - sensor_msgs/msg/Imu messages on the '/gps/heading' topic to "imu_link", and
  - sensor_msgs/msg/NavSatFix messages on the '/gps/fix' topic to "gps_left_link".
All messages are written into a new bag.
"""

import sys
from rosbag2_py import StorageOptions, ConverterOptions, SequentialReader, SequentialWriter
from sensor_msgs.msg import Imu, NavSatFix
from rclpy.serialization import deserialize_message, serialize_message

def modify_imu_message(data):
    """Deserialize and modify Imu message's header.frame_id to 'imu_link'."""
    imu_msg = deserialize_message(data, Imu)
    imu_msg.header.frame_id = "imu_link"
    return serialize_message(imu_msg)

def modify_navsatfix_message(data):
    """Deserialize and modify NavSatFix message's header.frame_id to 'gps_left_link'."""
    gps_msg = deserialize_message(data, NavSatFix)
    gps_msg.header.frame_id = "gps_left_link"
    return serialize_message(gps_msg)

def main(input_bag_path: str, output_bag_path: str):
    # Set up storage and converter options.
    storage_options = StorageOptions(uri=input_bag_path, storage_id='sqlite3')
    converter_options = ConverterOptions(
        input_serialization_format='cdr',
        output_serialization_format='cdr'
    )
    
    # Initialize reader for the input bag.
    reader = SequentialReader()
    reader.open(storage_options, converter_options)
    
    # Initialize writer for the output bag.
    writer = SequentialWriter()
    writer_storage_options = StorageOptions(uri=output_bag_path, storage_id='sqlite3')
    writer.open(writer_storage_options, converter_options)
    
    # Copy all topics from the input bag to the output bag.
    topics = reader.get_all_topics_and_types()
    for topic in topics:
        writer.create_topic(topic)
    
    # Process every message.
    while reader.has_next():
        (topic, data, timestamp) = reader.read_next()
        
        if topic == '/gps/heading':
            # Modify Imu message.
            data = modify_imu_message(data)
        elif topic == '/gps/fix':
            # Modify NavSatFix message.
            data = modify_navsatfix_message(data)
        
        writer.write(topic, data, timestamp)
    
    print(f"Modification completed. Modified bag written to: {output_bag_path}")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 main.py <input_bag_path> <output_bag_path>")
        sys.exit(1)
    input_bag = sys.argv[1]
    output_bag = sys.argv[2]
    main(input_bag, output_bag)
