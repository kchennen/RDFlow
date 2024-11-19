from subprocess import run

# Tiny script to check if conda, mamba, make and git are installed
all_installed = True
for requirement in ['conda', 'mamba', 'make', 'git status', 'gh']:
    try:
        process_run = run(requirement.split(), capture_output=True)
        if process_run. returncode == 0:
            print(f"✅ {requirement} installed!")
        else:
            print(f"❌ {requirement} does not seem to be installed correctly. See the README for help getting this tool ready.")
            all_installed = False
    except PermissionError as e:
        print(f"❌ {requirement} does not seem to be installed correctly. See the README 📖 for help getting this tool ready. 🤓")
        all_installed = False

if all_installed:
    print()
    print("🎉 Congratulations! You have all the requirements to get started! 🎉")
    print("🥳 You're ready! Now it's time to begin. 🚀")
    print("🤓 If you're not sure what to do next, run `make help` to see a list of commands. 📜")