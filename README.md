# KHULA JARVIS

A cross-platform assistant with a Kivy/KivyMD mobile interface, Android APK packaging, Gemini chat, speech input/output, limited desktop automation, and a project-scoped coding agent.

## Start

1. On Windows, install Python 3.10 or newer and run `run.cmd`. It creates `.venv` and installs the packages from `requirements.txt`.
2. Set `GEMINI_API_KEY` in a local `.env` file or your user environment. KHULA reloads `.env` at startup and before each prompt. `GEMINI_MODEL` optionally overrides the default `gemini-3.5-flash-lite` model.
3. The app opens with an isolated `agent_workspace` folder. Use **Select project** to choose another existing project before asking for code changes.

On desktop, the continuous Hindi/English voice listener starts when the app opens and uses Google's speech recognition endpoint, so it requires a microphone and internet access. Pause/resume it with **MIC ON/OFF**. Spoken responses use Edge TTS and pygame. On Android, tap **MIC ON** to launch the system speech recognizer; speech is one-shot rather than background always-listening. Android spoken responses use the device TTS service. Speech permissions are requested at runtime.

## Android APK

`buildozer.spec` is configured for an arm64 Android APK with internet and microphone permissions. The mobile app uses Gemini's HTTPS API directly, avoiding the native-extension-heavy desktop SDK in the Android build. Build on Linux or in Google Colab (Buildozer is not supported natively on Windows). Upload the project as a ZIP to Colab, open `colab_build_apk.ipynb`, and run its cells in order. The final cell downloads the debug APK. Do not bundle `.env` or API credentials in the APK; enter the Gemini key in the app's **API KEY** dialog, where it is stored in the app's private data directory.

## Use

- Type a request and press Enter or **Send** for Gemini chat.
- Use `/code <task>` to start the project-scoped code/build/repair loop. Typed coding requests ask for confirmation; spoken coding requests auto-run within existing project boundaries. On Android, the workspace is inside the app's private data directory.
- Speak naturally for chat, or say “open notepad”, “show files”, or “list processes” to use the existing allowlisted actions. Spoken screenshot requests still ask before capture/upload.
- Use `/open notepad`, `/open calculator`, `/open explorer`, or `/open vscode` for the fixed application allowlist.
- Use `/files` to list the selected project's files, `/openfile <relative path>` to open one, or `/shortcut ctrl+s` for a shortcut from the fixed allowlist.
- Use `/processes` for a partial process listing.
- `/files`, `/openfile <relative path>`, `/shortcut <key>`, and `/open <allowlisted app>` provide the supported utility actions. Screen capture and process listing are desktop-only.
- Chats auto-save to the app's private data directory; **New** starts another conversation.

## Safety and limitations

This is a local assistant, not an unrestricted autonomous administrator. Android microphone use is user initiated through the system recognizer. The coding agent only writes relative paths inside its selected workspace, blocks secret/VCS/virtual-environment paths, and only runs detected Python compile/tests, .NET build, or npm build/test commands. Screen capture and arbitrary shell access are not exposed by the mobile interface. Gemini requests send prompts to Google's API; keep API credentials out of source archives and APK builds.

Gemini requests send prompts and attached images to Google's API. Keep API credentials in environment variables or a local `.env`; never commit them. API quotas and model availability depend on Google's current free-tier terms.

## Layout

- `main.py`: Kivy/KivyMD app and dispatch
- `core/brain.py`: Gemini chat and structured code generation
- `core/coder.py`: project-scoped edits, build checks, and repair loop
- `core/voice.py`: Hindi/English speech recognition and local TTS
- `core/automation.py`: allowlisted app launch, process listing, screenshots
- `tray/service.py`: tray icon and global hotkey
- `tests/test_safety.py`: focused safety tests
- `buildozer.spec`: Android packaging configuration
- `colab_build_apk.ipynb`: Google Colab APK build notebook
