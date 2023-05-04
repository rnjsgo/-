package hangangview.appserver.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Table(name = "social")
@Entity
@Builder
@NoArgsConstructor
public class Social extends Question{

}
