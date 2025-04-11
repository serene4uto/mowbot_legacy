import os
import signal
import subprocess
from time import sleep
import tkinter as tk


class ToggleScriptButton:
    def __init__(self, master, start_script_path, end_script_path, name):
        self.start_script_path = start_script_path
        self.end_script_path = end_script_path
        self.name = name  # Custom name for the script
        self.state = 'Start'  # Initial state of the button

        self.frame = tk.Frame(master, bd=5, relief='ridge')
        self.frame.pack(pady=10, padx=10, fill='x', expand=True)

        self.label = tk.Label(
            self.frame,
            text=self.name,
            width=30,  # Adjust width
            anchor='w',
            font=('Arial', 16)  # Bigger font
        )
        self.label.pack(side='left', padx=20, pady=10)

        self.button = tk.Button(
            self.frame,
            text='Start',
            width=12,  # Adjust button width
            height=2,  # Adjust button height
            font=('Arial', 14, 'bold'),  # Bigger and bold font
            command=self.on_button_click
        )
        self.button.pack(side='left', padx=20, pady=10)

    def on_button_click(self):
        if self.state == 'Start':
            self.start_process()
        else:
            self.terminate_process()

    def start_process(self):
        """Execute the bash script file in a new terminal window."""
        if not os.path.isfile(self.start_script_path):
            print(f"Script file not found: {self.start_script_path}")
            return

        subprocess.Popen(
            ['gnome-terminal', '--', '/bin/bash', self.start_script_path],
            preexec_fn=os.setsid
        )
        self.state = 'End'
        self.button.config(text='End')
        print(f"Started script: {self.name}")

    def terminate_process(self):
        """Execute the end script to terminate the process."""
        if not os.path.isfile(self.end_script_path):
            print(f"End script file not found: {self.end_script_path}")
            return

        subprocess.Popen(
            ['/bin/bash', self.end_script_path],
            preexec_fn=os.setsid
        )

        self.button.config(state='disabled')
        print("Terminating...")
        sleep(2)
        self.button.config(state='normal')
        self.state = 'Start'
        self.button.config(text='Start')
        print(f"Executed end script: {self.name}")


def main():
    root = tk.Tk()
    root.title("AMR MowBot Demo")
    
    # Remove fullscreen attributes
    # root.attributes("-fullscreen", True)  # Comment out or remove this line
    
    # Configure window properties
    root.resizable(True, True)  # Allow window to be resizable
    # root.geometry(f"{screen_width}x{screen_height}+0+0")  # Remove fixed geometry
    
    # No need for escape binding as it's not fullscreen
    # root.bind('<Escape>', lambda e: root.destroy())  # Can keep this if desired
    
    # Create header with title and exit button
    header_frame = tk.Frame(root, bg="#3366CC", height=80)
    header_frame.pack(fill="x", padx=0, pady=0)
    header_frame.pack_propagate(False)
    
    title_label = tk.Label(
        header_frame,
        text="AMR MowBot Control Panel",
        font=("Arial", 18, "bold"),  # Reduced font size
        bg="#3366CC",
        fg="white"
    )
    title_label.pack(side="left", padx=20, pady=15)
    
    exit_button = tk.Button(
        header_frame,
        text="Exit",
        font=("Arial", 12, "bold"),  # Reduced font size
        bg="#FF6666",
        fg="white",
        command=root.destroy,
        width=6,  # Smaller button
        height=1
    )
    exit_button.pack(side="right", padx=20, pady=15)
    
    # Create main content area
    content_frame = tk.Frame(root, bg="#F0F0F0")
    content_frame.pack(fill="both", expand=True, padx=15, pady=15)

    scripts = [
        {
            'name': 'AMR Bring Up',
            'start_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'amr-bring-up.sh'
            ),
            'end_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'term-amr-bring-up.sh'
            ),
        },
        {
            'name': 'AMR Health Monitor',
            'start_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'amr-health-monitor.sh'
            ),
            'end_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'term-amr-health-monitor.sh'
            ),
        },
        {
            'name': 'GPS Waypoint Logger',
            'start_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'amr-gps-wp-logger.sh'
            ),
            'end_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'term-amr-gps-wp-logger.sh'
            ),
        },
        {
            'name': 'GPS Waypoint Follower',
            'start_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'amr-gps-wp-follower.sh'
            ),
            'end_script_path': (
                '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/'
                'term-amr-gps-wp-follower.sh'
            ),
        }
    ]

    for script_info in scripts:
        ToggleScriptButton(
            content_frame,
            script_info['start_script_path'],
            script_info['end_script_path'],
            script_info['name']
        )

    def run_clean_script():
        """Execute the clean script and update status."""
        clean_script_path = '/home/mowbot/mowbot_legacy/test_assets/scripts_dev/clean.sh'

        if not os.path.isfile(clean_script_path):
            print(f"Clean script not found: {clean_script_path}")
            status_label.config(text="Error: Clean script not found!")
            return

        status_label.config(text="Cleaning system...")
        print("Running clean script...")

        subprocess.Popen(
            ['/bin/bash', clean_script_path],
            preexec_fn=os.setsid
        )

        # Temporarily disable the button to prevent multiple clicks
        clean_button.config(state='disabled')
        root.after(2000, lambda: clean_button.config(state='normal'))
    
    clean_button = tk.Button(
        header_frame,
        text="Clean",
        font=("Arial", 12, "bold"),
        bg="#4CAF50",  # Green color
        fg="white",
        command=run_clean_script,
        width=6,
        height=1
    )
    clean_button.pack(side="right", padx=10, pady=15)
    
    # Add status bar at the bottom
    status_bar = tk.Frame(root, bg="#DDDDDD", height=30)
    status_bar.pack(fill="x", side="bottom")
    
    status_label = tk.Label(
        status_bar,
        text="Ready",
        bg="#DDDDDD",
        anchor="w"
    )
    status_label.pack(side="left", padx=10)
    
    # Update the status label when the window is created
    def update_status():
        from datetime import datetime
        now = datetime.now()
        status_label.config(text=f"System ready | {now.strftime('%Y-%m-%d %H:%M:%S')}")
        root.after(1000, update_status)
    
    root.after(100, update_status)
    
    root.mainloop()


if __name__ == "__main__":
    main()