package hangangview.appserver.repository;

import hangangview.appserver.domain.Creativity;
import hangangview.appserver.domain.Question;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CreativityRepository extends JpaRepository<Creativity,Long> {
    List<Creativity> findAll();
}
