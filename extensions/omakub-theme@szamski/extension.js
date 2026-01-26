const {Gio, GLib, GObject} = imports.gi;
const Main = imports.ui.main;
const PopupMenu = imports.ui.popupMenu;
const QuickSettings = imports.ui.quickSettings;

function getBasePath() {
  const envPath = GLib.getenv('OMAKUB_SZAMSKI_PATH');
  if (envPath && envPath.length > 0)
    return envPath;
  return `${GLib.get_home_dir()}/.local/share/omakub-szamski`;
}

function titleCase(input) {
  return input
    .split('-')
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ');
}

function listThemes(basePath) {
  const themeDir = `${basePath}/themes`;
  const themes = [];

  if (!GLib.file_test(themeDir, GLib.FileTest.IS_DIR))
    return themes;

  const dir = Gio.File.new_for_path(themeDir);
  try {
    const enumerator = dir.enumerate_children('standard::name,standard::type', Gio.FileQueryInfoFlags.NONE, null);
    let info;
    while ((info = enumerator.next_file(null)) !== null) {
      if (info.get_file_type() !== Gio.FileType.DIRECTORY)
        continue;
      const name = info.get_name();
      const gnomePath = `${themeDir}/${name}/gnome.sh`;
      if (GLib.file_test(gnomePath, GLib.FileTest.EXISTS))
        themes.push(name);
    }
  } catch (err) {
    return themes;
  }

  themes.sort();
  return themes;
}

function applyTheme(basePath, theme) {
  const applyPath = `${basePath}/themes/apply-theme.sh`;
  if (!GLib.file_test(applyPath, GLib.FileTest.EXISTS))
    return;

  const argv = ['bash', '-lc', `source "${applyPath}" "${theme}"`];
  const launcher = new Gio.SubprocessLauncher({ flags: Gio.SubprocessFlags.NONE });
  launcher.setenv('OMAKUB_SZAMSKI_PATH', basePath, true);
  launcher.spawnv(argv);
}

const ThemeIndicator = GObject.registerClass(
class ThemeIndicator extends QuickSettings.SystemIndicator {
  _init() {
    super._init();

    this._toggle = new QuickSettings.QuickMenuToggle({
      title: 'Theme',
      iconName: 'preferences-desktop-theme-symbolic',
      menuEnabled: true,
    });

    this._toggle.menu.connect('open-state-changed', () => {
      this._rebuildMenu();
    });

    this.quickSettingsItems.push(this._toggle);
    this._rebuildMenu();
  }

  _rebuildMenu() {
    this._toggle.menu.removeAll();

    const basePath = getBasePath();
    const themes = listThemes(basePath);

    if (themes.length === 0) {
      const item = new PopupMenu.PopupMenuItem('No themes found', { reactive: false });
      this._toggle.menu.addMenuItem(item);
      return;
    }

    themes.forEach(theme => {
      const item = new PopupMenu.PopupMenuItem(titleCase(theme));
      item.connect('activate', () => {
        applyTheme(basePath, theme);
      });
      this._toggle.menu.addMenuItem(item);
    });
  }
});

let indicator = null;

function enable() {
  indicator = new ThemeIndicator();
  Main.panel.statusArea.quickSettings.addExternalIndicator(indicator);
}

function disable() {
  if (indicator) {
    indicator.destroy();
    indicator = null;
  }
}
