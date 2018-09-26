import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="good_talks",
    version="0.0.2",
    author="Joshua B. Smith",
    author_email="kognate@gmail.com",
    description="A small example package for a packaging talk",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/kognate/presentations/2018/packaging_talk",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3 :: Only",
        "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
        "Operating System :: OS Independent",
    ],
)
