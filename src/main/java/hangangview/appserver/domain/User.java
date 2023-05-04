package hangangview.appserver.domain;

import lombok.*;

import javax.persistence.*;

@Table(name = "user")
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name="id")
    private Long id;

    @Column(name="userId", columnDefinition = "varchar(256)")
    private String userId;

    @Column(name="password", columnDefinition = "varchar(256)")
    private String password;

    @Column(name="name", columnDefinition = "varchar(256)")
    private String name;

}
