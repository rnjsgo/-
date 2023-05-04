package hangangview.appserver.repository;

import hangangview.appserver.domain.Personality;
import hangangview.appserver.domain.Question;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.ArrayList;
import java.util.List;

public interface PersonalityRepository extends JpaRepository<Personality,Long> {
    ArrayList<Personality> findAll();
}
