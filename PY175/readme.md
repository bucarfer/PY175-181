# PY130 Exercises
### 🔗 How to create a local repository and Link to GitHub (Quick Steps)

1. **Create and enter your project folder:**
cd documents/0.2LaunchSchool/VS_Repository/
mkdir repo_name
cd repo_name


2. **Initialize Git:**
git init

3. **Create a GitHub repo with same name (empty, no README).**

4. **Link GitHub repo:**
git remote add origin https://github.com/bucarfer/my_project.git
git remote add origin https://github.com/bucarfer/PY130-139

5. **Add and commit files:**
git add .
git commit -m "Initial commit"


6. **Push to GitHub:**

   git branch -M main
   git push -u origin main
   ```

### Git Workflow Checklist for VS Code

🔄 Before You Start Coding (Optional but Good Habit)
Open Terminal in VS Code
git pull --no-rebase

This ensures you have the latest version from GitHub before you start working.
📝 While You Work
Make changes to your files.
Save often (Cmd+S or Ctrl+S).

💾 After You Finish a Session (Commit + Push)
1️⃣ Stage your changes
bash
git add .
git commit -m "describe what you did"
git push

🔄 When Switching Devices (or Collaborating)
If you work on this repo from another device, always pull first:
bash
git pull --no-rebase

🚨 If Git Refuses to Pull (Conflicts or Divergence)
Check if you have uncommitted changes.
Either:
Commit your changes.
Or stash your changes:bashCopyEditgit stash

Then try:bash
git pull --no-rebase

If you stashed changes, bring them back
bash: git stash pop