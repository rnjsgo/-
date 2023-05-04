package hangangview.appserver.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Table(name = "creativity")
@Entity
@Builder
@NoArgsConstructor
public class Creativity extends Question{

}
