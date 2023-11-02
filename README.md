# font-action

## Generate dependencies list


### New variant

```
docker run  pip freeze gftools > requirements.txt
```

### Old variant

```
pip3 install pipdeptree
python3 -m pipdeptree --freeze  --warn silence -p 'gftools' -e pngquant_cli |grep -v setuptools|gsed -E 's/^\s*(.+?)==.*$/\1/g' |sort |uniq
```
