package hangangview.appserver.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Table(name = "suitability")
@Entity
@Builder
@NoArgsConstructor
public class Suitability extends Question{

}
