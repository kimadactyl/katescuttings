```SQL
SELECT node.nid, node.title, node.type, node.created, field_data_body.body_value
FROM node
JOIN field_data_body
ON node.nid = field_data_body.entity_id
```

```SQL
SELECT field_data_field_images.entity_id, file_managed.fid, file_managed.filename
FROM file_managed
JOIN field_data_field_images
ON file_managed.fid = field_data_field_images.field_images_fid
```
