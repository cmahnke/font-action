`font-action`
=============

# Building

```
docker build -f docker/hiero/Dockerfile .
```

# Generate dependencies list


## New variant
**This is't working yet**

```
docker run  pip freeze gftools > requirements.txt
```
Piping maight reduce number of variants
` | sed 's/==/<=/g' `

## Old variant

```
pip3 install pipdeptree
python3 -m pipdeptree --freeze  --warn silence -p 'gftools' -e pngquant_cli |grep -v setuptools|gsed -E 's/^\s*(.+?)==.*$/\1/g' |sort |uniq
```
