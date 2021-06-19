import os, subprocess
# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables

class __fzf(Command):
    """
    Helper class for fzf methods.

    See: https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration
    """
    command = ""
    options = ""

    def execute(self):
        if 'fzf' not in get_executables():
            self.fm.notify('Could not find fzf in the PATH.', bad=True)
            return

        env = os.environ.copy()
        command = self.command if isinstance(self.command, str) \
             else self.command()
        options = "--ansi --preview='_preview_path {}'" + " " + self.options
        env['FZF_DEFAULT_COMMAND'] = command
        env['FZF_DEFAULT_OPTS'] += " " + options
        fzf = self.fm.execute_command('fzf --no-multi', env=env,
                                      universal_newlines=True,
                                      stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)

class fzf_select(__fzf):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def command(self) -> str:
        """ Uses fd (https://github.com/sharkdp/fd) if it is available. """
        fd = None
        if 'fdfind' in get_executables():
            fd = 'fdfind'
        elif 'fd' in get_executables():
            fd = 'fd'

        if fd is not None:
            hidden = ('--hidden' if self.fm.settings.show_hidden else '')
            exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
            only_directories = ('--type directory' if self.quantifier else '')
            fzf_default_command = '{} --follow {} {} {} --color=always'.format(
                fd, hidden, exclude, only_directories
            )
        else:
            hidden = ('-false' if self.fm.settings.show_hidden else r"-path '*/\.*' -prune")
            exclude = r"\( -name '\.git' -o -iname '\.*py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
            only_directories = ('-type d' if self.quantifier else '')
            fzf_default_command = 'find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-'.format(
                hidden, exclude, only_directories
            )

        return fzf_default_command

class fzf_z(__fzf):
    """
    :fzf_z
    Integrates fzf with z for directory jumping.

    See: https://github.com/rupa/z (https://github.com/jethrokuan/z for fish)
    """
    command = "_z"
    options = "--tiebreak=index"

