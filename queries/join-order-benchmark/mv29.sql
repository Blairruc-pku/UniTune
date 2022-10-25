SELECT ci.role_id,
        ci.person_role_id,
        ci.person_id,
        ci.note,
        ci.movie_id
FROM cast_info AS ci
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)');