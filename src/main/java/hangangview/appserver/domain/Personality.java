package hangangview.appserver.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Table(name = "personality")
@Entity
@Builder
@NoArgsConstructor
public class Personality extends Question{

}
