"""Create a source ZIP using the same exclusions as publication review."""
from pathlib import Path
import importlib.util
import zipfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('publication', ROOT / 'scripts/check_publication.py')
publication = importlib.util.module_from_spec(spec)
spec.loader.exec_module(publication)
findings = publication.scan()
if findings:
    raise SystemExit('\n'.join(findings))

output = ROOT.parent / 'reading-stations-explorer-github.zip'
extra_skip = {'.flutter-plugins', '.flutter-plugins-dependencies', '.packages',
              '.last_build_id', '.DS_Store'}
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path, relative in publication.candidates():
        if path.name in extra_skip or path.suffix in {'.iml'}:
            continue
        archive.write(path, Path(ROOT.name) / relative)
print(f'Created {output.name}')
