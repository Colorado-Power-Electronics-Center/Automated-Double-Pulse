# python markdown module must be installed as well as pygments for syntax highlighting
import markdown
import codecs
from string import Template
import glob
import os.path

# Get list of markdown files
md_files = glob.glob("*.md")

for fn in md_files:
    file_name = os.path.splitext(fn)[0]
    md_file = file_name + '.md'
    html_file = file_name + '.html'

    input_file = codecs.open(md_file, mode="r", encoding="utf-8")

    text = input_file.read()

    extension_configs = {
        'mdx_math': {
            'enable_dollar_delimiter': 'True'
        },
        'markdown.extensions.toc': {
            'anchorlink': 'False',
            'separator': '_'
        }
    }

    html = markdown.markdown(text, extensions=['mdx_math', 'markdown.extensions.fenced_code', 'markdown.extensions.tables',
                                               'markdown.extensions.toc', 'markdown.extensions.codehilite'],
                             extension_configs=extension_configs)

    output_file = codecs.open("body.html", "w",
                              encoding="utf-8",
                              errors="xmlcharrefreplace")

    output_file.write(html)
    output_file.close()

    # Set Title
    d = {'Title': file_name}
    header_file = codecs.open("header.html", mode="r", encoding="utf-8")
    header_text = Template(header_file.read())
    header_text = header_text.substitute(d)

    temp_header = codecs.open("temp_header.html", "w", encoding="utf-8")
    temp_header.write(header_text)
    temp_header.close()

    # Merge HTML Files (Template, and Body)
    filenames = ['temp_header.html', 'body.html', 'footer.html']
    with open(html_file, 'w') as outfile:
        for fname in filenames:
            with open(fname) as infile:
                for line in infile:
                    outfile.write(line)


os.unlink("temp_header.html")
os.unlink("body.html")
